'use strict'

// ffmpeg device list parser library
const parse = require('./lib/ffmpeg-device-list-parser.js').parse;

// FFmpegPath is customizable
const options = {
	ffmpegPath: '"../ffmpeg/ffmpeg.exe"'
}

// ShareX configuration constants
const MICROPHONE = "microphone";

// Task description to identify the mic audio recording task
const MIC_REC_TASK_DESCRIPTION = "Morphic: Record region to desktop with mic audio";

// Task description to identify the computer + mic audio recording task
const STEREO_MIX_REC_TASK_DESCRIPTION = "Morphic: Record region to desktop with computer and mic audio";

// Placeholder string to be replaced with real microphone name in the custom command below 
const MIC_PLACEHOLDER = "{mic-name}";

// Custom command for the computer + mic audio recording task
const CUSTOM_COMMAND_STEREO_REC = `-y -rtbufsize 150M -f dshow -i audio="virtual-audio-capturer" -f dshow -i audio="${MIC_PLACEHOLDER}" -f gdigrab -framerate $fps$ -offset_x $area_x$ -offset_y $area_y$ -video_size $area_width$x$area_height$ -draw_mouse $cursor$ -i desktop -filter_complex "[0:a][1:a]amerge=inputs=2[a]" -map 2 -map "[a]" -c:v libx264 -r $fps$ -preset ultrafast -tune zerolatency -crf 28 -pix_fmt yuv420p -movflags +faststart -c:a aac -strict -2 -ac 2 -b:a 128k "$output$"`;

// Path to the ShareX config file which specifies the recording tasks
const HOTKEY_CONFIG_FILE = '../sharex-portable/ShareX/HotkeysConfig.json';

var fs = require("fs");

// Promise usage
parse(options).then(function(ffmpeg_devices) {
    var mic_name = getMicrophoneName(ffmpeg_devices);
    console.log(mic_name);
    if (mic_name) {
        var config_json = readConfigToJson(HOTKEY_CONFIG_FILE, 'utf8');
        writeMicNameToConfig(config_json, mic_name);
        writeStereoMixRecCommand(config_json, mic_name);
        writeConfigToFile(HOTKEY_CONFIG_FILE, config_json, 'utf8');
    }
});

// Returns the name the first microphone found in ffmpeg list-devices command
function getMicrophoneName(ffmpeg_devices) {
    var mic_name = null;
    if (ffmpeg_devices.audioDevices.length) {
        ffmpeg_devices.audioDevices.forEach(function(audioDevice) {
            if (audioDevice.name.toLowerCase().includes(MICROPHONE)) {
                mic_name = audioDevice.name;
                return mic_name;
            }
        });
    }
    return mic_name;
}

function writeMicNameToConfig(config_json, mic_name) {
    var taskSettings;
    for (var i = 0; i < config_json.Hotkeys.length; i++) {
        var element = config_json.Hotkeys[i];
        if (element.TaskSettings.Description.includes(MIC_REC_TASK_DESCRIPTION)) {
            taskSettings = element.TaskSettings;
            taskSettings.CaptureSettings.FFmpegOptions.AudioSource = mic_name;
            break;
        }
    }
}

function writeStereoMixRecCommand(config_json, mic_name) {
    var taskSettings;
    for (var i = 0; i < config_json.Hotkeys.length; i++) {
        var element = config_json.Hotkeys[i];
        if (element.TaskSettings.Description.includes(STEREO_MIX_REC_TASK_DESCRIPTION)) {
            taskSettings = element.TaskSettings;
            taskSettings.CaptureSettings.FFmpegOptions.UseCustomCommands = true;
    		taskSettings.CaptureSettings.FFmpegOptions.CustomCommands = CUSTOM_COMMAND_STEREO_REC.replace(MIC_PLACEHOLDER, mic_name);
    		console.log(taskSettings.CaptureSettings.FFmpegOptions.CustomCommands);
            break;
        }
    }
}

function readConfigToJson(filepath, encoding) {
    return JSON.parse(fs.readFileSync(filepath, encoding));
}

function writeConfigToFile(filepath, json, encoding) {
    fs.writeFileSync(filepath, JSON.stringify(json), encoding);
}

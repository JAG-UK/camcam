# camcam
Cam water level camera on lightweight rpi and ffmpeg stream.
See it in action at https://cityrc.co.uk/camcam

## Overview

<img width="1842" height="517" alt="High level architecture of Cam Cam" src="https://github.com/user-attachments/assets/a94f1fb7-6240-4469-a16f-b5a1bfff8ff1" />

## Hardware Bill of Materials

 * Raspberry Pi 5 with stock Raspbian
 * Good quality USB camera (the reference deployment uses a long focus 1080P 2MP waterproof outdoor camera from SVPro)
   
## Deployment

### Prerequisites

Network:
 * Raspberry Pi/camera side: requires a stable network conection capable of sustaining a constant 900kbps (ish) upload. This is exptremely modest for home wifi but may challenge public access points or limited cell connections.
 * Streaming service side: requires a fixed IP address routable from the public Internet with ports 443 (serving) and 1935 (RTMP ingestion from the camera) exposed. Must be able to reliably ingestthe 900kbps inbound stream (per feed). Capacity and outbound bandwidth requirements are varibale depending on number of streams and number of connected clients. The reference deployment uses a small size Digital Ocean Droplet (1GB RAM, 25GB disk).

Software:
 * Raspberry Pi:
   * `ffmpeg` - for streaming the feed
   * `v4lutils` - for management of USB-connected cameras
 * Cloud server:
   * GitHub CLI if you want easy updates
   * docker with docker compose
  
### Running a deployment

#### On the Raspberry Pi:

1. Clone this repo: `git clone https://github.com/JAG-UK/camcam.git`
1. Go to the Pi scripts directory `cd rpi`
1. Edit the upload script with your variables `vi stream-uploader.sh`
1. Register as a resident service and start the stream: `sudo ./register-service.sh`

Bonus points: scheduled hours

If you want to have the camera feed automatically start and stop at certain times of day (eg 06:00-22:00), edit your crontab to look like this:

```
# Stream between 06:00 and 22:00
0 6 * * *  sudo systemctl start stream-uploader.service
0 22 * * * sudo systemctl stop stream-uploader.service
```

#### On the cloud server:

1. Clone this repo: `git clone https://github.com/JAG-UK/camcam.git`
1. Set the stream secret in the environment: `export STREAM_KEY=somethingOnlyYouKnow`
1. Put your email address (for LetsEncrypt) in Caddyfile (TODO: make this an env var, along with the DNS name)
1. Bring it up: `cd camcam && docker compose up --build`
1. Test it (live feed): https://your.domain.name/live.html
1. Test it (latest snapshot): https://your.domain.name/snapshot.jpg

#### On your website:

If you want more than just a full screen video, the stream can be embedded into your website as an `iFrame` with this simple snippet:

```html
<iframe
  src="https://camcam.cityrc.co.uk/frame.html"
  width="1280"
  height="720"
  frameborder="yes"
  scrolling="no"
  allowfullscreen="true">
</iframe>
```

It is quite likely that you will experience issues with the `Content Security Policy` of the website not wishing to serve content from the remote source. I cannot advise on how to fix this in detail becasue many hosting services are different and vary in their support for editing CSP headers, but I'm sure their help desk will tell you how to do it.

## Debugging and local testing

### Cloud server software:

The software supports local testing over HTTP so that you can make changes or make sure thigs are OK before getting into cloud server configuration, DNS and TLS configuration and so on.

Simply set all the env vars in a terminal and then `docker comopose up --build` and it should all run. Errors will be reported in the terminal.

### Raspberry Pi

 * Ensure the Pi can route to port 1935 on the local development machine.
 * Stop the `systemctl` service (it'll fight with your test processes). Don't forget to re-enable it when you're done!
 * In a terminal, run the `stream-helper.sh` directly, replacing the RTMP target with your test machine's IP address. `ffmpeg` will tell you any errors it encounters. If it claims 'Device is in use' or similar, hunt down and kill other `ffmpeg` or `stream-helper` processes.

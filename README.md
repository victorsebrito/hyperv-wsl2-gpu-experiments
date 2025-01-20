# hyperv-wsl2-gpu-experiments

I've been looking into some issues with GPU acceleration in WSL recently and I found myself testing multiple setups (Ubuntu, Alpine, different kernels, building mesa and libva from source, etc.).

I figured it was time to document all my work when I started wanting to go back to a specific setup to perform additional validations, but I wasn't even versioning my Dockerfiles. 🥲 I'm not sure if I'll have time to continue working on this, but I'll update the repo if I do.

## TL;DR

Use the following command to execute all tests:

```bash
docker compose run --build --rm ubuntu2204 /tests/all.sh
```

You can replace `ubuntu2204` with other setups (see [compose.yml](./compose.yml)) and `/tests/all.sh` with any other command (like `bash`).

## Context

I have a mini PC (i7 1260P, 32GB RAM) that I use for:
- hosting some 24/7 Docker services like [Plex](https://www.plex.tv/) (it does some hardware transcoding with the iGPU);
- educational purposes (playing around with k8s, Proxmox and all that);
- streaming and recording in OBS with an USB capture card;
- lightweight gaming (retro emulators, Fall Guys, etc.) with Bluetooth gamepads.

Ubuntu Desktop has been its main OS for the past year just because it works for my workloads. I've always prefered Windows (general user experience, look and feel) and now I'm making the switch. Thing is, I don't want to give up HW transcoding in Plex. I know I could just run Plex directly on Windows, but then what would be the fun?

## Hardware Transcoding in Plex

I've already managed to successfully do HW transcoding in Docker containers running on WSL, but Plex itself still fails to load the drivers:

```
[Req#149/Transcode] Codecs: testing h264 (decoder) with hwdevice vaapi
[Req#149/Transcode] Codecs: hardware transcoding: testing API vaapi for device '' ()
[Req#149/Transcode] [FFMPEG] - libva: dlopen of /usr/lib/x86_64-linux-gnu/dri/d3d12_drv_video.so failed: Error relocating /usr/lib/x86_64-linux-gnu/dri/d3d12_drv_video.so: fcntl64: symbol not found
[Req#149/Transcode] [FFMPEG] - Failed to initialise VAAPI connection: -1 (unknown libva error).
[Req#149/Transcode] Codecs: hardware transcoding: opening hw device failed - probably not supported by this system, error: I/O error
[Req#149/Transcode] Could not create hardware context for h264
```
This is probably an issue because of [this](https://forums.plex.tv/t/plex-media-server-forum-preview-faster-and-smaller-builds-with-new-toolchain/699575) and others have gone through it before (see [this reply](https://forums.plex.tv/t/got-hw-transcoding-to-work-with-libva-vaapi-on-ryzen-apu-ryzen-7-4700u/676546/46) and [this Dockerfile](https://github.com/skjnldsv/docker-plex/blob/1befd2c7fe571b4558fdc63498e4545b7f6844b8/Dockerfile)).

I don't have much expertise with this kind of issue, but my best bet right now is to make WSL GPU acceleration work in a [musl-based](https://wiki.musl-libc.org/projects-using-musl.html) distro (like Alpine) to see if Plex will be able to load the drivers.

So far I've only got the GPU to work on Ubuntu 22.04 using the latest official Mesa drivers. On Ubuntu 24.04, I got it working when I built Mesa drivers from source, but faced the same issue with Plex. I also managed to build and install the drivers on Alpine, but not even `vainfo` worked. I'll see if I can recreate the Dockerfiles I used and store them in this repo.

## Updates

I'll use this section when I have updates. Feel free to open an issue or contribute with a PR.

## My personal goal

The ideal setup is to have an **Windows 11 host with an Hyper-V VM running Ubuntu Server**. GPU acceleration should be available in both OSs, and Windows should also be accessible via HDMI with mouse and keyboard support.

### Why not:
- **Use Proxmox with Windows and Ubuntu VMs:**
  - [PCI passthrough](https://pve.proxmox.com/wiki/PCI_Passthrough) would not let me use the GPU in both VMs at the same time.
  - [vGPUs](https://www.derekseaman.com/2024/07/proxmox-ve-8-2-windows-11-vgpu-vt-d-passthrough-with-intel-alder-lake.html) would stop the HDMI ports from working.
- **Have Ubuntu as the host and use a Windows VM**:
  - Did this a couple times when I needed to do some Windows specific task, but now I want to do everything on Windows (including OBS and gaming).
  - VMWare provides decent experience because I can attach USB devices with ease and it has 3D acceleated graphics, but it doesn't work for OBS. I didn't even try gaming.
  - KVM is [far behind](https://github.com/virtio-win/kvm-guest-drivers-windows/issues/841) for my use cases.
- **Use WSL instead of Hyper-V VM:**
  - This is actually my plan B. It's just not my first option because I prefer having full control over the VM.
  - WSL requires workarounds for things that are mandatory for a server (see [#6782](https://github.com/microsoft/WSL/issues/6782), [#8835](https://github.com/microsoft/WSL/issues/8835) and [#12333](https://github.com/microsoft/WSL/issues/12333))
  - I don't even know if I'll be able to make the GPU work directly on Hyper-V. I just figured that if it works on WSL, it's **technically** possible, right? 😅

## Additional links

- [D3D12 GPU Video acceleration in the Windows Subsystem for Linux now available!](https://devblogs.microsoft.com/commandline/d3d12-gpu-video-acceleration-in-the-windows-subsystem-for-linux-now-available/)
- [Containerizing GUI applications with WSLg
](https://github.com/microsoft/wslg/blob/861d029e97bc99e68050f86c956803b42e8756da/samples/container/Containers.md)
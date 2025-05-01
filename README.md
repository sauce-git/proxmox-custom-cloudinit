# Custom proxmox cloud-init

## Description

This is a custom cloud-init generator for Proxmox. This automatically generates iso image and attaches it to the VM.

## Usage

1. Setup environment
   You can use .env file to set up the environment variables. The script will automatically load the variables from the .env file.

2. Clone the repository on your Proxmox server

```bash
git clone https://github.com/sauce-git/proxmox-custom-cloudinit.git
cd proxmox-custom-cloudinit
```

3. Customize the cloud-init

```bash
vi cloud-init.yaml
```

4. Generate cloud-init

```bash
./build.sh <vmid>
```

## Example

```bash
./build.sh 100
```

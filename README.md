# Firecracker playground

## prepare the environement

first, getting KVM device access:
```
sudo setfacl -m u:${USER}:rw /dev/kvm
```

second, building and executing the firecracker container and its proxy companion (a basic socat for the time being):
```
mkdir images # volume to be bound to the firecracker container
docker-compose build
docker-compose up -d
```

in case we need to clean up things later (including the shared volume with the control socket): 
```
docker-compose down -v
```


## following the tutorial

downloading the test kernel and rootfs of the original quick start guide(https://github.com/firecracker-microvm/firecracker/blob/master/docs/getting-started.md):
```
cd images
curl -fsSL -o hello-vmlinux.bin https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin
curl -fsSL -o hello-rootfs.ext4 https://s3.amazonaws.com/spec.ccfc.min/img/hello/fsfiles/hello-rootfs.ext4
```


configure the kernel through API: 
```
curl -X PUT 'http://localhost:12345/boot-source' -H 'Accept: application/json'  -H 'Content-Type: application/json'  \
    -d '{
        "kernel_image_path": "/tmp/images/hello-vmlinux.bin",
        "boot_args": "console=ttyS0 reboot=k panic=1 pci=off"
    }'
```

configure the root filesystem through API:
```
curl -X PUT 'http://localhost:12345/drives/rootfs' \
    -H 'Accept: application/json'           \
    -H 'Content-Type: application/json'     \
    -d '{
        "drive_id": "rootfs",
        "path_on_host": "/tmp/images/hello-rootfs.ext4",
        "is_root_device": true,
        "is_read_only": false
    }'
```

start the guest machine through API:
```
curl -X PUT 'http://localhost:12345/actions' \
    -H  'Accept: application/json' \
    -H  'Content-Type: application/json' \
    -d '{
        "action_type": "InstanceStart"
     }'
```

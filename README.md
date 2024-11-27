# Server Monitor

This repository is configured to trigger a push alert if the CPU load exceeds the defined threshold for 10 consecutive minutes or if disk usage surpasses the specified limit.

## Scripts

### monitor.sh
This script is the main entry point for monitoring the server. It calls `cpu.sh` and `disk.sh` to gather CPU and disk usage statistics.

You should set a cronjob to run this script at every 5 mintues.

### cpu.sh
This script monitors the CPU usage of the server and will send a push notification if cpu is too high. If cpu is very high, it will perform a reboot in order to prevent the server from crashing.

### disk.sh
This script monitors the disk usage of the server. If the disk usage is too high, it will send a push notification.

## Usage

To use these scripts, make sure they have execute permissions:

```sh
chmod +x monitor.sh cpu.sh disk.sh
```

Then, you can run the main monitoring script:

```sh
./monitor.sh
```

## License

This project is licensed under the MIT License.
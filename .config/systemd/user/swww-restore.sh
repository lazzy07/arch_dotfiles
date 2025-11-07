[Unit]
Description=Reapply swww wallpaper after suspend/resume
After=suspend.target
Wants=suspend.target

[Service]
Type=oneshot
ExecStart=/bin/sh -lc '~/.local/bin/swww-restore.sh'

[Install]
WantedBy=suspend.target


× borgbackup-job-system-backup-eu.service - BorgBackup job system-backup-eu
     Loaded: loaded (/etc/systemd/system/borgbackup-job-system-backup-eu.service; linked; preset: ignored)
     Active: failed (Result: exit-code) since Sun 2025-03-02 03:36:00 UTC; 1s ago
   Duration: 1.137s
 Invocation: da89fdf6f99343e089569f5455606829
TriggeredBy: ● borgbackup-job-system-backup-eu.timer
    Process: 61828 ExecStart=/nix/store/kpi55i3l2m60ra0qb7z26s6g5nflgcgs-unit-script-borgbackup-job-system-backup-eu-start/bin/borgbackup-job-system-backup-eu-start (code=exited, status=2)
   Main PID: 61828 (code=exited, status=2)
         IP: 3.8K in, 4K out
         IO: 3.9M read, 0B written
   Mem peak: 69.7M
        CPU: 673ms

Mär 02 03:35:59 qframe13 borgbackup-job-system-backup-eu-start[61854]: zroot/tmp        44G  640K   44G   1% /tmp
Mär 02 03:35:59 qframe13 borgbackup-job-system-backup-eu-start[61828]: Creating snapshot zroot/root@backup-20250302-033559
Mär 02 03:35:59 qframe13 borgbackup-job-system-backup-eu-start[61828]: Sending zroot/root@backup-20250302-033559 to file
Mär 02 03:36:00 qframe13 borgbackup-job-system-backup-eu-start[61905]: Remote: Host key verification failed.
Mär 02 03:36:00 qframe13 borgbackup-job-system-backup-eu-start[61905]: Connection closed by remote host. Is borg working on the server?
Mär 02 03:36:00 qframe13 borgbackup-job-system-backup-eu-start[61912]: Remote: Host key verification failed.
Mär 02 03:36:00 qframe13 borgbackup-job-system-backup-eu-start[61912]: Connection closed by remote host. Is borg working on the server?
Mär 02 03:36:00 qframe13 systemd[1]: borgbackup-job-system-backup-eu.service: Main process exited, code=exited, status=2/INVALIDARGUMENT
Mär 02 03:36:00 qframe13 systemd[1]: borgbackup-job-system-backup-eu.service: Failed with result 'exit-code'.
Mär 02 03:36:00 qframe13 systemd[1]: borgbackup-job-system-backup-eu.service: Consumed 673ms CPU time, 69.7M memory peak, 3.9M read from disk, 3.8K incoming IP traffic, 4K outgoing IP traffic.

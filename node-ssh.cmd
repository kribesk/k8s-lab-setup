@ECHO OFF
ECHO Connecting to node-%1...
ssh -i config/sshkeys/ssh_private core@node%1.example.com
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i config/sshkeys/ssh_private core@node1.example.com 'sudo shutdown now'
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i config/sshkeys/ssh_private core@node2.example.com 'sudo shutdown now'
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i config/sshkeys/ssh_private core@node3.example.com 'sudo shutdown now'

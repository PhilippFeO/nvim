local nmap = require 'utils'.nmap('Octo')

nmap('<Leader>ic', '<Cmd>Octo issue create<CR>', '[i]ssue [c]reate')
nmap('<Leader>ie', ':Octo issue edit ', '[i]ssue [e]dit')
nmap('<Leader>il', '<Cmd>Octo issue list<CR>', '[i]ssue [l]ist')

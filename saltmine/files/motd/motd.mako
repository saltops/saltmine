Welcome to host ${ grains['id'] }:
 - Architecture: ${ grains['cpuarch'] }
 - OS: ${ grains['osfullname'] } ${ grains['osrelease'] }
 - CPU: ${ grains['num_cpus'] }
 - Memory: ${ grains['mem_total'] } Mb

% if 'roles' in grains:
  % for role in grains['roles']:
 - Role: ${role}
  % endfor
% endif
% if 'group' in grains:
 - Group: ${ grains['group']}
% endif

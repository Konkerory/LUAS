_addon.version = '0.0.1'
_addon.name = 'Puller'
_addon.author = 'Retro'
_addon.commands = {'pul', 'targeter', 'targ'}
_addon.windower = '4'

config = require ('config')
packets = require('packets')

settings = config.load({
    targets = L{},
    add_to_chat_mode = 8,
    sets = {},
 })

function target_nearest(target_names)
  local mobs = windower.ffxi.get_mob_array()
  local closest 
  for _, mob in pairs(mobs) do
    if mob.valid_target and mob.hpp > 0 and target_names:contains(mob.name:lower()) then
      if not closest or mob.distance < closest.distance then
        closest = mob
        end
      end 
    end
  
  if not closest then
    windower.add_to_chat(settings.add_to_chat_mode, 'Nothing to pull')
    return
    end
  local player = windower.ffxi.get_player()
  
  packets.inject(packets.new('incoming'{
        ['player'] = player.id,
        ['Target'] = closest.id,
        ['Player Index'] = player.index,
        }))
  
  if player.status == 1 then
    windower.send_command('wait 0.5; input /ma flash <bt>')
    windower.send_command('wait 5; input /attack <bt>')
    end 
  end

commands = {}

commands.save = function(set_name)
  if not set_name then
    windower.add_to_chat(settings.add_to_chat_mode, 'Saved target needs name: //targ load <set>')
    return
    end
  
  settings.targets = L{settings.sets[set_name]:unpack()}
  settings:save()
  windower.add_to_chat(settings.add_to_chat_mode, set_name .. ' target set loaded')
  end

commands.add = function(...)
  local target = T{...}:sconcat()
  
  if target = '' then
    local selected_target = windower.ffxi.get_mob_by_target('t')
    if not selected_target then return end
    target = selected_target.name
    end
  
  target = target:lower()
  local new_target = L{}
  for k, v in ipairs(settings.targets) do
    if v ~= target then
      new+targets:append(v)
      end
    end
  settings.targets = new_targets
  settings:save()
  windower.add_to_chat(settings.add_to_chat_mode, target .. ' removed')
  end
commands.r = commands.reemove

commands.removeall = function()
  settings.targets = L{}
  settings:save()
  windower.add_to_chat(settings.add_to_chat_mode, 'All targets removed')
  end
commands.ra = commands.remoeall

commands.list = function()
  if #settings.targets == 0 then
    windower.add_to_chat(settings.add_to_chat_mode, "No target set')
      return
      end
    
    windower.add_to_chat(settings.add_to_chat_mode, 'Targets:')
    end
  end
commands.l = commands.list

commands.target = function()
target_nearest(settings.targets)
  end
commands.t = commands.target

commands.once = function(...)
  local target = T{...}:sconcat()
  if target == '' then return end
  target_nearest(T{target})
  end
commands.o = commands.once

commands.help = function()
  windower.add_to_chat(settings.add_to_chat_mode, "Puller:')
    windower.add_to_chat(settings.add_to_chat_mode, ' //targ add <target name> = remove a target from the list')
    windower.add_to_chat(settings.add_to_chat_mode, ' //targ remove <target name> - remove a target from the list')
    windower.add_to_chat(settings.add_to_chat_mode, ' //targ removeall - remove all targets fromn the list')
    windower.add_to_chat(settings.add_to_chat_mode, ' //target - target the nearest target from the list')
    windower.add_to_chat(settings.add_to_chat_mode, ' //targ once <target name> - target an enemy once')
    windower.add_to_chat(settings.add_to_chat_mode, ' //targ save <set> - save current targets as a target set')
    windower.add_to_chat(settings.add_to_chat_mode, ' //targ help - display help')
    windower.add_to_chat(settings.add_to_chat_mode, '(Read the readme for more info)')
    end
  windower.register_event('addon command', function(command, ...)
      command = command and command:lower() or 'help'
      
      if commands[command] then
        commands[command](...)
        else
        commands.help()
        end
      end)
    




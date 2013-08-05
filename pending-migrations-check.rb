#!/usr/bin/env ruby

    def set_color(color, default = 0)
      case color.downcase.gsub("\n", '')
        when /\d/ then color
        when 'black' then '0'
        when 'red' then '1'
        when 'green' then '2'
        when 'yellow' then '3'
        when 'blue' then '4'
        when 'magenta' then '5'
        when 'cyan' then '6'
        when 'white' then '7'
        else
          default
      end
    end

    automigrate = `git config rails.automigrate`.index('true')
    migratable = `git diff --name-only HEAD@{1} HEAD`.index("db/migrate")
    fg_color = set_color(`git config rails.automigrateforegroundcolor`, 7)
    bg_color = set_color(`git config rails.automigratebackgroundcolor`, 0)
    blink = (`git config rails.automigrateblink`.index('true')) ? 5 : 0

    if migratable
      if automigrate
        puts "\e[#{blink};1;3#{fg_color};4#{bg_color}mMigrating Database... Please wait.\e[0m"
        `rake db:migrate && rake db:test:prepare`
        puts "\e[#{blink};1;3#{fg_color};4#{bg_color}mDone migrating database.\e[0m"
      else
        puts "\e[#{blink};1;3#{fg_color};4#{bg_color}mThere are pending migrations.\e[0m"
      end
    end

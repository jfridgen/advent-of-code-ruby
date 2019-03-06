require 'date'

LINE_FORMAT = /^\[(?<timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2})\] (Guard #)?(?<guard_id>\d*)\s?(?<activity_type>.+)$/

def parse_line(line)
    m = line.match(LINE_FORMAT)
    # can use m.named_captures instead starting in ruby 2.4
    m.names.zip(m.captures).to_h
end

# parse input, sort by timestamp, and calculate sleep
guard_id = nil
sleep_start_time = nil
observations = File.readlines('day4input.txt')
    .map { |line| parse_line(line) }
    .sort_by { |observation| observation['timestamp'] }
    .each { |observation|
        if observation['activity_type'] == 'begins shift'
            guard_id = observation['guard_id']
            observation['sleep_minutes'] = 0
        elsif observation['activity_type'] == 'falls asleep'
            sleep_start_time = observation['timestamp']
            observation['guard_id'] = guard_id
            observation['sleep_minutes'] = 0
        elsif observation['activity_type'] == 'wakes up'
            observation['sleep_minutes'] = ((DateTime.parse(observation['timestamp']) -  DateTime.parse(sleep_start_time)) * 24 * 60).to_i
            observation['guard_id'] = guard_id
        end
    }

guard_observations = Array.new
sleep_by_minute = Hash.new(0)
sleep_start_minute = nil
sleep_end_minute = nil

# aggregate a particular guard observation
observations
    .each { |observation|
        if observation['activity_type'] == 'falls asleep'
            sleep_start_minute = DateTime.parse(observation['timestamp']).min
        elsif observation['activity_type'] == 'wakes up'
            sleep_end_minute = (DateTime.parse(observation['timestamp']).min) - 1
            sleep_by_minute = Hash.new(0)
            for min in sleep_start_minute..sleep_end_minute
                sleep_by_minute[min] += 1
            end
            guard_observations.push({ 'guard_id' => observation['guard_id'], 'sleep_by_minute' => sleep_by_minute, 
                'total_minutes_slept' => sleep_by_minute.values.reduce { |sum, value| sum + value} })
        end
    }

# aggregate all guard observations
guard_observations.each do |x|
    guard_observations.each do |y|
        if (x != y) && (x['guard_id'] == y['guard_id'])
            x['sleep_by_minute'] = x['sleep_by_minute'].merge(y['sleep_by_minute']) { |key, oldval, newval| oldval + newval }
            x['total_minutes_slept'] = x['total_minutes_slept'] + y['total_minutes_slept']
            y['sleep_by_minute'] = Hash.new(0)
            y['total_minutes_slept'] = 0
        end
    end
end

#Find guard_id with max total_minutes_slept
#Find max sleep_by_minute value for this guard_id
#Multiple this guard_id by max sleep_by_minute key
guard_max_sleep = guard_observations.max_by { |x| x['total_minutes_slept'] }
max_minute = guard_max_sleep['sleep_by_minute'].max_by { |k,v| v }
puts guard_max_sleep['guard_id'].to_i * max_minute[0].to_i

#Find guard_id with max sleep_by_minute value, multiply guard_id by corresponding sleep_by_minute key
guard_max_sleep_by_minute = guard_observations.max_by do |x|
    (x['sleep_by_minute'].values.max.is_a? Numeric) ? x['sleep_by_minute'].values.max : 0
end
max_minute = guard_max_sleep_by_minute['sleep_by_minute'].max_by { |k,v| v }
puts guard_max_sleep_by_minute['guard_id'].to_i * max_minute[0].to_i
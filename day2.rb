ids = File.readlines('day2input.txt')

#Part 1
twoCount = 0
threeCount = 0

ids.each do |line|
    ('a'..'z').each do |char|
       if line.count(char) == 2
        twoCount += 1
        break
       end
    end
end

ids.each do |line|
    ('a'..'z').each do |char|
       if line.count(char) == 3
        threeCount += 1
        break
       end
    end
end

puts twoCount
puts threeCount
puts twoCount * threeCount

#Part 2
for x in ids
    for y in ids
        diff = 0
        for i in 0..x.length-1
            if x[i] != y[i]
                diff += 1
            end
        end
        if diff == 1
            ans = []
            for i in 0..x.length-1
                if x[i] == y[i]
                    ans.push(x[i])
                end
            end
            puts ans.join('')
            puts x,y
        end
    end
end
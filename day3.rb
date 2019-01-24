LINE_FORMAT = /^#(?<claim_id>\d+) .* (?<inches_from_left>\d+),(?<inches_from_top>\d+): (?<width>\d+)x(?<height>\d+)$/

def parse_line(line)
    m = line.match(LINE_FORMAT)
    # can use m.named_captures instead starting in ruby 2.4
    m.names.zip(m.captures).to_h
end

def find_xy(claim_data)
    right_most_x_coord = claim_data['inches_from_left'].to_i + claim_data['width'].to_i - 1
    x_coords = *(claim_data['inches_from_left'].to_i..right_most_x_coord)

    bottom_most_y_coord = claim_data['inches_from_top'].to_i + claim_data['height'].to_i - 1
    y_coords = *(claim_data['inches_from_top'].to_i..bottom_most_y_coord)

    claim_xy_coords = []
    x_coords.each do |x|
        y_coords.each do |y|
            xyCoord = { 'x' => x, 'y' => y }
            claim_xy_coords.push(xyCoord)
        end
    end

    return claim_xy_coords
end

puts File.readlines('day3input.txt')
    .map { |line| parse_line(line) }
    .flat_map { |claim_data| find_xy(claim_data) }
    .each_with_object(Hash.new(0)) { |xy_coord, counts| counts[xy_coord] += 1 }
    .select { |xy_coord, count| count > 1}
    .count
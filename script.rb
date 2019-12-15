filenames = Dir[
  'information-security/*.md',
  'computer-networks/*.md',
  'operating-systems/*.md'
]

filenames.each do |filename|
  File.open(filename, 'r+') do |file|
    content = file.read

    new_content = content.sub(/(?<=---\n)(.*?)(?=\n---)/m) do |frontmatter|
      entries = {}

      frontmatter.split("\n").each do |front_matter_entry|
        front_matter_entry.match(/(?<key>.+): (?<value>.+)/) do |kv_pair|
          entries[kv_pair[:key]] = kv_pair[:value]
        end
      end

      course = File.dirname(file)
      lecture = File.basename(file, '.md')

      entries['course'] = course
      entries['lecture'] = lecture
      entries['id'] = [course, lecture].join('-')
      entries.delete('sidebar_label')

      entries.to_a.map { |entry| entry.join(': ') }.join("\n")
    end

    file.pwrite(new_content, 0)
  end
end

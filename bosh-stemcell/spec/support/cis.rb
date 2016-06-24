require 'set'

$cis_test_cases = Set.new

RSpec.configure do |config|
  config.before(:each) do |example|
    puts "example: #{example.full_description}"
    if example.full_description.include? "CIS-"
      puts "-------------------------- CIS example: #{example.full_description}"
      puts "-------------------------- CIS scan result: #{example.full_description.scan /CIS-(?:\d+\.?)+/}"
      $cis_test_cases += example.full_description.scan /CIS-(?:\d+\.?)+/
    end
  end

  config.register_ordering(:global) do |list|
    # make sure that cis test case check will be run at last
    list.each do |example_group|
      puts "-------------------------- cis.rb example_group.metadata: #{example_group.metadata}"
      if example_group.metadata[:cis_check]
        list.delete example_group
        list.push example_group
        break
      end
    end

    puts "-------------------------- list: #{list}"
    list
  end
end

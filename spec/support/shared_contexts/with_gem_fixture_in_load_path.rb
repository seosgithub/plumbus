def with_gem_in_load_path name
  shared_context "with #{name} gem in load path" do
    name = name.to_s

    load_path = File.expand_path "./spec/fixtures/gems/#{name}/lib"

    before(:each) do
      $: << load_path
      env_load = ENV["RUBYLIB"].split(":")
      env_load << load_path
      ENV["RUBYLIB"] = env_load.join(":")
    end

    after(:each) do
      $:.delete(load_path)
      env_load = ENV["RUBYLIB"].split(":")
      env_load.delete(load_path)
      ENV["RUBYLIB"] = env_load.join(":")
    end
  end
end

with_gem_in_load_path :plumbus_fake_driver

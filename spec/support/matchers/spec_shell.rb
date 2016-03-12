RSpec::Matchers.define :have_timed_out do
  match do |spec_shell|
    return spec_shell.timed_out?
  end

  description do
    "have timed out"
  end
end

RSpec::Matchers.define :have_succeeded do
  match do |spec_shell|
    return spec_shell.succeeded?
  end

  description do
    "have succeeded"
  end
end


RSpec::Matchers.define :have_failed do
  match do |spec_shell|
    return spec_shell.failed?
  end

  description do
    "have failed"
  end
end

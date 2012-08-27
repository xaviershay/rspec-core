require "spec_helper"

describe "deprecations" do
  describe "Spec" do
    it "is deprecated" do
      RSpec.should_receive(:warn_deprecation).with(/Spec .* RSpec/i)
      Spec
    end

    it "returns RSpec" do
      RSpec.stub(:warn_deprecation)
      Spec.should eq(RSpec)
    end

    it "doesn't include backward compatibility in const_missing backtrace" do
      RSpec.stub(:warn_deprecation)
      exception = nil
      begin
        ConstantThatDoesNotExist
      rescue Exception => exception
      end
      exception.backtrace.find { |l| l =~ /lib\/rspec\/core\/backward_compatibility/ }.should be_nil
    end
  end

  %w[example running_example].each do |example_accessor|
    describe RSpec::Core::ExampleGroup do
      describe example_accessor do
        it 'is deprecated' do
          RSpec.should_receive(:warn_deprecation)
          send(example_accessor)
        end

        it "delegates to yielded example" do |ex|
          RSpec.stub(:warn_deprecation)
          send(example_accessor).should eq(ex)
        end
      end
    end
  end

  describe "Spec::Runner.configure" do
    it "is deprecated" do
      RSpec.stub(:warn_deprecation)
      RSpec.should_receive(:deprecate)
      Spec::Runner.configure
    end
  end

  describe "Spec::Rake::SpecTask" do
    it "is deprecated" do
      RSpec.stub(:warn_deprecation)
      RSpec.should_receive(:deprecate)
      Spec::Rake::SpecTask
    end

    it "doesn't include backward compatibility in const_missing backtrace" do
      RSpec.stub(:warn_deprecation)
      exception = nil
      begin
        Spec::Rake::ConstantThatDoesNotExist
      rescue Exception => exception
      end
      exception.backtrace.find { |l| l =~ /lib\/rspec\/core\/backward_compatibility/ }.should be_nil
    end
  end

end

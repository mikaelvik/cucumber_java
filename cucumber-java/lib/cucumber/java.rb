require 'cucumber/java/version'
require "cucumber-java-#{Cucumber::Java::VERSION::STRING}.jar"
import 'cucumber.internal.StepDefinition'
import 'cucumber.Table'

module Cucumber
  module Ast
    class Table
      include ::Java::Cucumber::Table
    end
  end
  
  module PureJava
    module StepDefinitionExtras
      def regexp
        Regexp.new(getRegexpString)
      end

      def invoke(world, args)
        begin
          invokeOnTarget(args)
        rescue Exception => e
          java_exception_to_ruby_exception(e)
          raise(java_exception_to_ruby_exception(e))
        end
      end

      private
    
      def java_exception_to_ruby_exception(java_exception)
        bt = java_exception.backtrace
        Exception.cucumber_strip_backtrace!(bt, nil, nil)
        exception = JavaException.new(java_exception.message)
        exception.set_backtrace(bt)
        exception
      end
      
      class JavaException < Exception
      end
    end

    def step_mother=(step_mother)
      @__cucumber_java_step_mother = step_mother
    end

    def step_mother
      @__cucumber_java_step_mother
    end

    def register_class(clazz)
      @__cucumber_java_step_mother.registerClass(clazz)
    end

    def new_world!
      @__cucumber_java_step_mother.newWorld
    end
    
    def step_definitions
      @__cucumber_java_step_mother.getStepDefinitions
    end
  end
end
extend(Cucumber::PureJava)

class Java::CucumberInternal::StepDefinition
  include Cucumber::StepDefinitionMethods
  include Cucumber::PureJava::StepDefinitionExtras
end

Exception::CUCUMBER_FILTER_PATTERNS.unshift(/^org\/jruby|^cucumber\/java|^org\/junit|^java\/|^sun\/|^\$_dot_dot_/)

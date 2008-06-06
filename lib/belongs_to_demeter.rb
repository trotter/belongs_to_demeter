module BelongsToDemeter
  def self.included(base)
    base.send(:extend, ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    def belongs_to(*args)
      belongs_to_demeter << args.first.to_sym
    end

    def belongs_to_demeter
      @__belongs_to_demeter ||= []
    end
  end

  module InstanceMethods
    def respond_to?(meth)
      for pre in self.class.belongs_to_demeter
        return true if meth.to_s =~ /^#{pre}_/
      end
      super
    end

    def method_missing(meth, *args, &block)
      for pre in self.class.belongs_to_demeter
        if meth.to_s =~ /^#{pre}_(.*)=$/
          obj = pre.to_s.classify.constantize.send("find_by_#{$1}", args.first)
          return send("#{pre}=", obj)
        elsif meth.to_s =~ /^#{pre}_/
          obj = self.send(pre)
          return obj ? obj.send($') : nil
        end
      end
      super
    end
  end
end

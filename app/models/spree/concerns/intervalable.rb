module Spree::Concerns
  module Intervalable
    extend ActiveSupport::Concern

    UNITS = {
      1 => :day,
      2 => :week,
      3 => :month,
      4 => :year
    }

    included do

      validates :times, :time_length, :time_unit, :time_unit_length, :presence => true
      validates_inclusion_of :time_unit, :in => UNITS.keys
      validates_inclusion_of :time_unit_length, :in => UNITS.keys

      # ex: :month
      def time_unit_symbol
        UNITS[time_unit]
      end

      def time_unit_length_symbol
        UNITS[time_unit_length]
      end

      # ex: "3 Months"
      def time_title
        "#{times} #{time_unit_symbol.to_s.pluralize(times).titleize}"
      end

      def time_length_title
        "#{time_length} #{time_unit_length_symbol.to_s.pluralize(time_length).titleize}"
      end

      # ex: 3.months
      def time
        times.try( time_unit_symbol )
      end

      def time_end
        time_length.try( time_unit_length_symbol )
      end

    end
  end
end

module Parsers
  module Helpers
    module SanitizeDates
      def months_ro_to_en(timestring)
        # Example 27 Aprilie 2014, ora 08:22
        timestring.gsub!("Aprilie",    "apr")
        timestring.gsub!("Mai",        "may")
        timestring.gsub!("Iunie",      "jun")
        timestring.gsub!("Iulie",      "jul")
        timestring.gsub!("August",     "aug")
        timestring.gsub!("Septembrie", "sep")
        timestring.gsub!("Octombrie",  "oct")
        timestring.gsub!("Noiembrie",  "nov")
        timestring.gsub!("Decembrie",  "dec")
        timestring.gsub!("Ianuarie",   "jan")
        timestring.gsub!("Februarie",  "feb")
        timestring.gsub!("Martie",     "mar")
        timestring
      end
    end
  end
end

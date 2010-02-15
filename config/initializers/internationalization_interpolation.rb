module I18n
  class << self
    def locale_around(locale, &block)
      begin
        original_locale = I18n.locale
        I18n.locale = locale
        return block.call
      ensure
        I18n.locale = original_locale
      end
    end
  end
end

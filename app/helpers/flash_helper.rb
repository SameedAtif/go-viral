module FlashHelper
  def flash_icon(flash_type)
    case flash_type
    when 'info', 'success', 'notice'
      'shared/svgs/success'
    when 'warning', 'alert'
      'shared/svgs/warning'
    when 'error'
      'shared/svgs/error'
    end
  end
end

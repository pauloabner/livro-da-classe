module ApplicationHelper

  def flash_message
    messages = button_tag('&#215;'.html_safe, :type => 'button', :class => 'close', :'data-dismiss' => 'alert', :name => nil)
    flash.each do |type, content|
      messages = content_tag(:div, messages + content, :class => "alert alert-#{ type == :notice ? "success" : "error" }")
    end
    messages
  end

  def full_text(book)
    a = String.new
    book.texts.each do |text|
      a << "\\chapter{#{text.title}}\n#{k_to_latex(text.content)}\n"
    end
    a
  end

  def k_to_latex(text)
    return Kramdown::Document.new(text).to_latex
  end

  def lesc(text)
    LatexToPdf.escape_latex(text)
  end

  def logged_in_as
    if session['admin_logged'].present?
      return "admin"
    elsif session['professor_logged'].present?
      return "professor"
    elsif session['student_logged'].present?
      return "estudante"
    end
  end

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

end
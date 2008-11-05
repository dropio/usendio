class AssetMailer < ActionMailer::Base

  def asset(asset, emails, message = nil)
    recipients emails
    from "no-reply@usend.io"
    subject "You've been sent a file from usend.io"
    body :asset => asset, :message => message
    content_type "text/html"
  end

end

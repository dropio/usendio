class HomeController < ApplicationController
  def index
    return unless request.post? && params_valid?

    @drop = Dropio::Drop.create({
      :guests_can_comment => true,
      :guests_can_add => false,
      :guests_can_delete => false,
      :expiration_length => "1_WEEK_FROM_LAST_VIEW"
      })
    
    original_directory = File.dirname(params[:upload][:file_data].local_path)
    new_file_path = File.join(original_directory, sanitize_filename(params[:upload][:file_data].original_filename))
    File.rename(params[:upload][:file_data].local_path, new_file_path)
    
    @asset = @drop.add_file(new_file_path)
    
    if @asset
      @recipients, bad_emails = [],[]
      emails = params[:recipients].split(",")
      filter = Regexp.new('^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$')
      emails.each {|email| (filter.match(email) ? @recipients : bad_emails) << email }

      @asset.send_to_emails(@recipients)

      redirect_to @asset.generate_url
    end
  end
  
  private

  def params_valid?
    return false if params[:recipients].blank?
    return false if params[:upload].blank? || params[:upload][:file_data].nil?
    return true
  end
  
  def sanitize_filename(value)
    just_filename = value.gsub(/^.*(\\|\/)/, '')
    @filename = just_filename.gsub(/[^\w\.\-]/,'_')
  end

end

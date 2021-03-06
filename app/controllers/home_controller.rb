require 'ftools'
class HomeController < ApplicationController
  def index
    return unless request.post? && params_valid?

    @drop = Dropio::Drop.create({
      :guests_can_comment => true,
      :guests_can_add => false,
      :guests_can_delete => false,
      :expiration_length => "1_WEEK_FROM_LAST_VIEW"
      })
      
      
    new_file_path = File.join(Dir::tmpdir, sanitize_filename(params[:upload][:file_data].original_filename))
    
    if params[:upload][:file_data].is_a? StringIO
      File.open(new_file_path, "w") { |file| file.write(params[:upload][:file_data].read) }
    else
      File.rename(params[:upload][:file_data].local_path, new_file_path)
    end
    
    @asset = @drop.add_file(new_file_path)
    
    @asset.create_comment("Email has been sent to the recipient(s) inviting them to view and download the sent file via usend.io, and you can invite others to view and download the media by linking directly to this page.")
    @asset.create_comment("This file has been uploaded via usend.io.  It is currently converting, and soon there will be a preview on this page (if it is a recognized format).")
    
    FileUtils.rm_rf(new_file_path)
    
    if @asset
      @recipients, bad_emails = [],[]
      emails = params[:recipients].split(",")
      filter = Regexp.new('^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$')
      emails.each {|email| (filter.match(email) ? @recipients : bad_emails) << email }

      AssetMailer.deliver_asset(@asset, @recipients)

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

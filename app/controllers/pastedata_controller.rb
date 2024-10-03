class PastedataController < ApplicationController
  def show
    @pastedata = Pastedatum.find(params[:id]) rescue not_found
  end

  def view
    @pastedata = Pastedatum.find(params[:pastedatum_id]) rescue not_found
    @pastedata.password = params[:password]
    begin
      @pastedata.data
    rescue OpenSSL::Cipher::CipherError
      head :unauthorized and return
    end
  end

  def new
  end

  def create
    if %i{data password}.any? do |sym| params[sym].blank? end
      head :bad_request and return
    end

    lines = params[:data].lines
    pairs = lines.map do |line|
      key = (line[/^[^:]*(?=:)/] || "").strip
      value = (line[/(?<=:).*$/] || "").strip
      [key, value]
    end

    data = pairs.to_h
    data.delete("")

    password = params[:password]

    pd = Pastedatum.new password: password, data: data
    pd.save!

    redirect_to pastedatum_path(pd)
  end
end

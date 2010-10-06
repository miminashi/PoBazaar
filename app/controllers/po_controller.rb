class PoController < ApplicationController
  def index
    @pos = Po.find(:all)
  end

  def new
    @po = Po.new
  end

  def create
    po_lines = []
    begin
      po_lines = params[:po][:file].readlines
    rescue
      flash[:error] = 'POファイルのオープンに失敗しました'
      redirect_to :action => 'index'
    else
      header = ""
      words = []
      begin
        potool = PoTools.new
        header, words = potool.porip(po_lines)
      rescue => e
        p e
        flash[:error] = 'POファイルの解析に失敗しました'
        redirect_to :action => 'index'
      else
        begin
          Po.transaction {
            @po = Po.new
            @po.name = params[:po][:name]
            @po.header = header
            @po.save
    
            words.each do |w|
              word = Word.new
              word.poid = @po.id
              word.place = w[:place]
              word.msgid = w[:msgid]
              if w[:msg_type] == 'msgstr'
                word.msg_type = 'msgstr'
                word.msgstr = w[:msgstr]
              elsif w[:msg_type] == 'msgstrs'
                word.msg_type = 'msgstrs'
                word.msgid_plural = w[:msgid_plural]
                word.msgstrs = w[:msgstrs]
              end
              word.save
            end
    
            @po.count = Word.count(:all, :conditions => ["poid = ?", @po.id])
            @po.save
          }
        rescue => e
          p e
          flash[:error] = 'データベースへの格納に失敗しました'
          redirect_to :action => 'show', :id => @po.id
        else
          flash[:notice] = 'POファイルの読み込みが完了しました'
          redirect_to :action => 'show', :id => @po.id
        end
      end
    end

  end

  def show
    @po = Po.find(params[:id])
  end

  def edit
    @po = Po.find(params[:id])
  end

  def update
    @po = Po.find(params[:id])

    if @po.update_attributes(params[:po])
      flash.now[:notice] = '更新しました'
      redirect_to :action => 'show', :id => params[:id]
    else
      flash.now[:error] = '更新に失敗しました'
      redirect_to :action => 'edit', :id => params[:id]
    end
  end

  def download
    po = Po.find(params[:id])
    words = Word.find_all_by_poid(params[:id])
    header = po.header
    messages = []
    words.each do |w|
      messages << {:msg_type => w.msg_type, :place => w.place, :msgid => w.msgid, :msgid_plural => w.msgid_plural, :msgstr => w.msgstr, :msgstrs => w.msgstrs}
    end
    potool = PoTools.new
    stream = StringIO.new(potool.pobuild(header, messages))
    send_data stream.string, :filename => "#{po.name}.po"
  end

  def destroy
  end

end

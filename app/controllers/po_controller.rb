require 'po'

class PoController < ApplicationController
  def index
    @pos = Po.find(:all)
  end

  def new

  end

  def create
    po_lines = []
    begin
      p 'into begin'
      po_path = RAILS_ROOT + '/lib/dev/noosfero.po'
      File.open(po_path, 'r') do |f|
        po_lines = f.readlines
      end
    rescue
      flash.now[:error] = 'POファイルのオープンに失敗しました'
      redirect_to :action => 'index'
    end

    p RAILS_ROOT
    p po_lines

    header = ""
    words = []
    begin
      header, words = porip(po_lines)
    rescue
      flash.now[:error] = 'POファイルの解析に失敗しました'
      redirect_to :action => 'index'
    end
   
    begin
      Po.transaction {
        @po = Po.new
        @po.name = 'noosfero.po'
        @po.header = header
        @po.save

        words.each do |w|
          word = Word.new
          word.poid = @po.id
          word.place = w[:place]
          word.msgid = w[:msgid]
          if w[:type] == 'msgstr'
            word.msg_type = 'msgstr'
            word.msgstr = w[:msgstr]
          elsif w[:type] == 'msgstrs'
            word.msg_type = 'msgstrs'
            word.msgid_plural = w[:msgid_plural]
            word.msgstrs = w[:msgstrs]
          end
          word.save
        end

        @po.count = Word.count(:all, :conditions => ["poid = ?", @po.id])
        @po.save
      }
    rescue
      flash.now[:notice] = 'データベースへの格納に失敗しました'
      redirect_to :action => 'show', :id => @po.id
    end

    flash[:notice] = 'POファイルの読み込みが完了しました'
    redirect_to :action => 'show', :id => @po.id
  end

  def show
    @po = Po.find(params[:id])
    #@count = Word.count(:conditions => "name = #{@po.name}")
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

  end

  def destroy
  end

end

class WordsController < ApplicationController
  # GET /words
  # GET /words.xml
  def index
    #@words = Word.all

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.xml  { render :xml => @words }
    #end
    redirect_to :controller => 'po', :action => 'index'
  end

  # GET /words/1
  # GET /words/1.xml
  def show
    @word = Word.find(params[:id])
    @po = Po.find(@word.poid)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @word }
    end
  end

  def show_messages
    #@words = Word.find_all_by_poid(params[:id])
    #@words = Word.paginate_all_by_poid(params[:id], :page => params[:page], :per_page => 10)
    @words = Word.paginate(:page => params[:page], :per_page => 20, :conditions => ["poid = ?", params[:id]])
    session[:prev_page] = params[:page]
    @po = Po.find(params[:id])
  end

  def show_all
    @words = Word.find_all_by_poid(params[:id])
    @po = Po.find(params[:id])
  end

  # GET /words/new
  # GET /words/new.xml
  def new
    @word = Word.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @word }
    end
  end

  # GET /words/1/edit
  def edit
    @word = Word.find(params[:id])
  end

  # POST /words
  # POST /words.xml
  def create
    @word = Word.new(params[:word])

    respond_to do |format|
      if @word.save
        format.html { redirect_to(@word, :notice => 'Word was successfully created.') }
        format.xml  { render :xml => @word, :status => :created, :location => @word }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @word.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /words/1
  # PUT /words/1.xml
  def update
    @word = Word.find(params[:id])

    respond_to do |format|
      if @word.update_attributes(params[:word])
        format.html { redirect_to(@word, :notice => 'Word was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @word.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.xml
  def destroy
    @word = Word.find(params[:id])
    @word.destroy

    respond_to do |format|
      format.html { redirect_to(words_url) }
      format.xml  { head :ok }
    end
  end
end

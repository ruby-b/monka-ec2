class TaggingsController < ApplicationController
  before_action :set_tagging, only: [:edit, :update, :destroy]
  before_action :set_book

  # GET /taggings/new
  def new
    @tagging = Tagging.new
  end

  # GET /taggings/1/edit
  def edit
  end

  # POST /taggings
  # POST /taggings.json
  def create
    @tagging         = Tagging.new(tagging_params)
    @tagging.book_id = @book.id

    respond_to do |format|
      if @tagging.save
        format.html { redirect_to @book, notice: 'Tagging was successfully created.' }
        format.json { render :show, status: :created, location: @tagging }
      else
        format.html { render :new }
        format.json { render json: @tagging.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /taggings/1
  # PATCH/PUT /taggings/1.json
  def update
    respond_to do |format|
      if @tagging.update(tagging_params)
        format.html { redirect_to @book, notice: 'Tagging was successfully updated.' }
        format.json { render :show, status: :ok, location: @tagging }
      else
        format.html { render :edit }
        format.json { render json: @tagging.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taggings/1
  # DELETE /taggings/1.json
  def destroy
    @tagging.destroy
    respond_to do |format|
      format.html { redirect_to @book, notice: 'Tagging was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tagging
      @tagging = Tagging.find(params[:id])
    end

    def set_book
      @book = Book.find(params[:book_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tagging_params
      params.require(:tagging).permit(:book_id, :tag_id)
    end
end

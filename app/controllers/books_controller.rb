class BooksController < ApplicationController
  layout 'public'

  before_filter :authentication_check
  before_filter :secure_organizer_id, :only => [:create, :update]
  before_filter :resource, :only => [:show, :edit, :destroy, :update]

  def index
    @books = current_user.books
  end

  def show
  end

  def new
    @book = current_user.books.new
  end

  def edit
  end

  def create
    @book = current_user.books.new(params[:book])

    if @book.save
      redirect_to @book, notice: 'Book was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @book.update_attributes(params[:book])
      redirect_to @book, notice: 'Book was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url
  end

  private

  def secure_organizer_id
    params[:book].delete(:organizer)
  end

  def resource
    @book = Book.find_by_uuid_or_id(params[:id])
  end
end

require 'spec_helper'

describe BooksController do
  let(:organizer)         { create(:organizer) }
  let(:books)             { organizer.books }
  let(:book)              { books.first }
  let(:valid_session)     { { :current_user => organizer } }
  let(:valid_attributes)  { attributes_for(:book, :organizer => organizer) }

  before do
    controller.stub(:current_user).and_return(valid_session[:current_user])
  end

  describe "GET index" do
    it "assigns all books as @books" do
      get :index, {}, valid_session
      assigns(:books).should eq(books)
    end
  end

  describe "GET show" do
    it "assigns the requested book as @book" do
      get :show, {:id => book.to_param}, valid_session
      assigns(:book).should eq(book)
    end
  end

  describe "GET new" do
    it "assigns a new book as @book" do
      get :new, {:organizer_id => valid_session[:current_user]}, valid_session
      assigns(:book).should be_a_new(Book)
    end
  end

  describe "GET edit" do
    it "assigns the requested book as @book" do
      get :edit, {:id => book.to_param}, valid_session
      assigns(:book).should eq(book)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Book" do
        expect {
          post :create, {:book => valid_attributes}, valid_session
        }.to change(Book, :count).by(1)
      end

      it "assigns a newly created book as @book" do
        post :create, {:book => valid_attributes}, valid_session
        assigns(:book).should be_a(Book)
        assigns(:book).should be_persisted
      end

      it "redirects to the created book" do
        post :create, {:book => valid_attributes}, valid_session
        response.should redirect_to(Book.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved book as @book" do
        Book.any_instance.stub(:save).and_return(false)
        post :create, {:book => {  }}, valid_session
        assigns(:book).should be_a_new(Book)
      end

      it "re-renders the 'new' template" do
        Book.any_instance.stub(:save).and_return(false)
        post :create, {:book => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested book" do
        Book.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => book.to_param, :book => { "these" => "params" }}, valid_session
      end

      it "assigns the requested book as @book" do
        put :update, {:id => book.to_param, :book => valid_attributes}, valid_session
        assigns(:book).should eq(book)
      end

      it "redirects to the book" do
        put :update, {:id => book.to_param, :book => valid_attributes}, valid_session
        response.should redirect_to(book)
      end
    end

    describe "with invalid params" do
      it "assigns the book as @book" do
        Book.any_instance.stub(:save).and_return(false)
        put :update, {:id => book.to_param, :book => {  }}, valid_session
        assigns(:book).should eq(book)
      end

      it "re-renders the 'edit' template" do
        Book.any_instance.stub(:save).and_return(false)
        put :update, {:id => book.to_param, :book => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested book" do
      expect {
        delete :destroy, {:id => book.to_param}, valid_session
      }.to change(Book, :count).by(-1)
    end

    it "redirects to the books list" do
      delete :destroy, {:id => book.to_param}, valid_session
      response.should redirect_to(books_url(:host => "test.host"))
    end
  end

end

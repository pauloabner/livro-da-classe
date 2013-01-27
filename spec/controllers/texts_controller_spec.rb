require 'spec_helper'

describe TextsController do
  let(:book)              { create(:book) }

  let(:valid_session)     { { :current_user => create(:user) } }
  let(:valid_attributes)  { { :title => "Text title", :book => book } }

  before do
    controller.stub(:current_user).and_return(valid_session[:current_user])
  end

  describe "GET index" do
    it "assigns all texts as @texts" do
      text = Text.create! valid_attributes
      get :index, {:book_id => book.id }, valid_session
      assigns(:texts).should eq([text])
    end
  end

  describe "GET show" do
    it "assigns the requested text as @text" do
      text = Text.create! valid_attributes
      get :show, {:id => text.to_param, :book_id => book.id}, valid_session
      assigns(:text).should eq(text)
    end
  end

  describe "GET new" do
    it "assigns a new text as @text" do
      get :new, {:book_id => book.id}, valid_session
      assigns(:text).should be_a_new(Text)
    end
  end

  describe "GET edit" do
    it "assigns the requested text as @text" do
      text = Text.create! valid_attributes
      get :edit, {:id => text.to_param, :book_id => book.id}, valid_session
      assigns(:text).should eq(text)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Text" do
        expect {
          post :create, {:text => valid_attributes,  :book_id => book.id}, valid_session
        }.to change(Text, :count).by(1)
      end

      it "assigns a newly created text as @text" do
        post :create, {:text => valid_attributes, :book_id => book.id}, valid_session
        assigns(:text).should be_a(Text)
        assigns(:text).should be_persisted
      end

      it "redirects to the created text" do
        post :create, {:text => valid_attributes, :book_id => book.id}, valid_session
        response.should redirect_to(book_text_path(Text.last.book, Text.last))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved text as @text" do
        # Trigger the behavior that occurs when invalid params are submitted
        Text.any_instance.stub(:save).and_return(false)
        post :create, {:text => {  }, :book_id => book.id}, valid_session
        assigns(:text).should be_a_new(Text)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Text.any_instance.stub(:save).and_return(false)
        post :create, {:text => {  }, :book_id => book.id}, valid_session
        response.should render_template("new")
      end
    end

    describe "with no params" do
      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        post :create, {:book_id => book.id}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested text" do
        text = Text.create! valid_attributes
        # Assuming there are no other texts in the database, this
        # specifies that the Text created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Text.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => text.to_param, :text => { "these" => "params" }, :book_id => book.id}, valid_session
      end

      it "assigns the requested text as @text" do
        text = Text.create! valid_attributes
        put :update, {:id => text.to_param, :text => valid_attributes, :book_id => book.id}, valid_session
        assigns(:text).should eq(text)
      end

      it "redirects to the text" do
        text = Text.create! valid_attributes
        put :update, {:id => text.to_param, :text => valid_attributes, :book_id => book.id}, valid_session
        # response.should redirect_to(book_text_path(text.book.id, text))
      end
    end

    describe "with invalid params" do
      it "assigns the text as @text" do
        text = Text.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Text.any_instance.stub(:save).and_return(false)
        put :update, {:id => text.to_param, :text => {  }, :book_id => book.id}, valid_session
        assigns(:text).should eq(text)
      end

      it "re-renders the 'edit' template" do
        text = Text.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Text.any_instance.stub(:save).and_return(false)
        put :update, {:id => text.to_param, :text => {  }, :book_id => book.id}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested text" do
      text = Text.create! valid_attributes
      expect {
        delete :destroy, {:id => text.to_param, :book_id => book.id}, valid_session
      }.to change(Text, :count).by(-1)
    end

    it "redirects to the texts list" do
      text = Text.create! valid_attributes
      delete :destroy, {:id => text.to_param, :book_id => book.id}, valid_session
      # response.should redirect_to(book_texts_url(text.book.id, :host => "test.host"))
    end
  end

end

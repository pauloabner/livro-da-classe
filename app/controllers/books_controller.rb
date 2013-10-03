# encoding: UTF-8

class BooksController < ApplicationController
  before_filter :authentication_check, :except => [:show]
  before_filter :ominiauth_user_gate, :except => [:show]
  before_filter :secure_organizer_id, :only => [:create, :update]
  before_filter :resource, :only => [:show, :edit, :destroy, :update, :cover_info, :update_cover_info, :generate_cover]

  require "#{Rails.root}/lib/book_cover.rb"

  def index
    @books = []
    @books.concat(current_user.organized_books).concat(current_user.books).flatten
  end

  def cover_info
    @cover_info = @book.cover_info
  end
  
  def update_cover_info
    if @book.cover_info.update_attributes(params[:cover_info])
      redirect_to book_cover_info_path(@book.uuid), notice: 'Capa atualizada com sucesso'
    else
      render :edit
    end
  end

  def generate_cover
    pdf_file = @book.cover_info.generate_pdf_cover
    
    respond_to do |format|
      format.pdf do |pdf|
        send_file pdf_file    
      end
    end
  end

  def show
    @scraps = @book.scraps.order("created_at desc")

    respond_to do |format|
      format.html # show.html.erb
      format.pdf 
    end
  end

  def new
    @book = current_user.organized_books.new
    @book.build_project
    @book.build_cover_info
    #raise ""
  end

  def create    
    @book = current_user.organized_books.new(params[:book].merge(:template => Livrodaclasse::Application.latex_templates[0]))
    if @book.save
      BookCover.new(@book.build_cover_info).generate_cover
      redirect_to book_path(@book.uuid), notice: 'O livro foi criado e já está disponível para você escrever o seu primeiro texto.'
    else
      render :new
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    params[:book].delete :project_attributes if params[:book][:project_attributes][:school_logo].blank?
    if params[:book][:cover_info_attributes][:capa_imagem].blank? and params[:book][:cover_info_attributes][:capa_detalhe].blank?
      params[:book].delete :cover_info_attributes 
    else
      params[:book][:cover_info_attributes].delete :capa_imagem  if params[:book][:cover_info_attributes][:capa_imagem].blank? 
      params[:book][:cover_info_attributes].delete :capa_detalhe  if params[:book][:cover_info_attributes][:capa_detalhe].blank?
    end
    
    if @book.update_attributes(params[:book])
      BookCover.new(@book.cover_info).generate_cover
      redirect_to book_path(@book.uuid), notice: 'O livro foi criado e já está disponível para você escrever o seu primeiro texto.'
    else
      render :edit
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
    @states = states
  end

  def states
    [["Acre", "AC"], ["Alagoas", "AL"], ["Amazonas", "AM"], ["Amapá", "AP"], ["Bahia", "BA"], ["Ceará", "CE"], ["Distrito Federal", "DF"], ["Espírito Santo", "ES"], ["Goiás", "GO"], ["Maranhão", "MA"], ["Minas Gerais", "MG"], ["Mato Grosso do Sul", "MS"], ["Mato Grosso", "MT"], ["Pará", "PA"], ["Paraíba", "PB"], ["Pernambuco", "PE"], ["Piauí", "PI"], ["Paraná", "PR"], ["Rio de Janeiro", "RJ"], ["Rio Grande do Norte", "RN"], ["Rondônia", "RO"], ["Roraima", "RR"], ["Rio Grande do Sul", "RS"], ["Santa Catarina", "SC"], ["Sergipe", "SE"], ["São Paulo", "SP"], ["Tocantins", "TO"]]
  end
end

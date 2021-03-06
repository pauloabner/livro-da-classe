class CoverInfo < ActiveRecord::Base
  belongs_to :book
  attr_accessible :texto_quarta_capa, :autor, :book_id, :organizador, :texto_na_lombada, :titulo_linha1, :titulo_linha2, :titulo_linha3, :cor_primaria, :cor_secundaria,
  :logo_x1, :logo_x2, :logo_y1, :logo_y2, :logo_w, :logo_h

  attr_accessible :capa_imagem, :capa_imagem_x1, :capa_imagem_x2, :capa_imagem_y1, :capa_imagem_y2, :capa_imagem_w, :capa_imagem_h
  has_attached_file :capa_imagem, :styles => { :normal => ["600x600>", :jpg], :small => ["300x300#", :jpg] }, :default_url => "/images/:style/missing.png"

  attr_accessible :capa_detalhe, :capa_detalhe_x1, :capa_detalhe_x2, :capa_detalhe_y1, :capa_detalhe_y2, :capa_detalhe_w, :capa_detalhe_h
  has_attached_file :capa_detalhe, :styles => { :normal => ["600x600>", :jpg], :small => ["300x300#", :jpg] }, :default_url => "/images/:style/missing.png"

  DEFAULT_CROP = "[0, 0, 30, 30]"

  validates_with ImageDimensionValidator, fields: [:capa_imagem, :capa_detalhe]

  validates_attachment_size :capa_imagem, :less_than => 1.gigabyte, :message => "O tamanho limite do arquivo (1GB) foi ultrapassado"
  validates_attachment_size :capa_detalhe, :less_than => 1.gigabyte, :message => "O tamanho limite do arquivo (1GB) foi ultrapassado"

  def cropping_logo?
    !logo_x1.blank? and !logo_y1.blank? and !logo_w.blank? and !logo_h.blank?
  end

  def cropping_capa?
    !capa_imagem_x1.blank? and !capa_imagem_y1.blank? and !capa_imagem_w.blank? and !capa_imagem_h.blank?
  end

  def cropping_detalhe?
    !capa_detalhe_x1.blank? and !capa_detalhe_y1.blank? and !capa_detalhe_w.blank? and !capa_detalhe_h.blank?
  end

  def logo_area
    if cropping_logo?
      "[#{logo_x1},#{logo_y1},#{logo_x2},#{logo_y2}]"
    else
      DEFAULT_CROP
    end
  end

  def capa_area
    if cropping_capa?
      "[#{capa_imagem_x1},#{capa_imagem_y1},#{capa_imagem_x2},#{capa_imagem_y2}]"
    else
      DEFAULT_CROP
    end
  end

  def detalhe_area
    if cropping_detalhe?
      "[#{capa_detalhe_x1},#{capa_detalhe_y1},#{capa_detalhe_x2},#{capa_detalhe_y2}]"
    else
      DEFAULT_CROP
    end
  end

  def capa_image_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file capa_imagem.path(style)
  end

  def capa_detalhe_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file capa_detalhe.path(style)
  end

  def primaria
    return self.cor_primaria.nil? ? '28572F' : self.cor_primaria
  end

  def secundaria
    return self.cor_secundaria.nil? ? '6F7551' : self.cor_secundaria
  end

  def capa_imagem_remove
    self.capa_imagem_file_name = nil
    self.capa_imagem_content_type = nil
    self.capa_imagem_file_size = nil
    self.capa_imagem_x1 = nil
    self.capa_imagem_x2 = nil
    self.capa_imagem_y1 = nil
    self.capa_imagem_y2 = nil
    self.capa_imagem_w = nil
    self.capa_imagem_h = nil
  end

  def capa_detalhe_remove
    self.capa_detalhe_file_name = nil
    self.capa_detalhe_content_type = nil
    self.capa_detalhe_file_size = nil
    self.capa_detalhe_x1 = nil
    self.capa_detalhe_x2 = nil
    self.capa_detalhe_y1 = nil
    self.capa_detalhe_y2 = nil
    self.capa_detalhe_w = nil
    self.capa_detalhe_h = nil
  end
end

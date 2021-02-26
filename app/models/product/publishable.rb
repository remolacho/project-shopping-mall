class Product
  module Publishable
    extend ActiveSupport::Concern
    # namejamos las siguientes reglas para publicar el prpducto
    # tener un producto master activo
    # que la suma de su stock no este en 0
    # que el producto este activo y su hide_from_results este falso
    # Que su precio no este en 0
    # que tenga una imagen

    included do
      before_update :published
    end

    def published
      self.can_published = is_active?
    end
  end
end

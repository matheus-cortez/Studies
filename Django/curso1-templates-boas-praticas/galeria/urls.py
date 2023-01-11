from django.urls import path
from galeria.views import index, imagem

urlpatterns = [
    path('', index, name='index'),
    path('imagem/', imagem, name='imagem') # criando uma nova rota para a qual seremos redirecionados
    # quando clicarmos em uma imagem. o parâmetro name permite que possamos referenciar esse path
    # no HTML usando {% url 'imagem' %} onde tiver imagem.html
]
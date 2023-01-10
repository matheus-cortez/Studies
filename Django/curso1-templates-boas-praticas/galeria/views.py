from django.shortcuts import render
# from django.http import HttpResponse #### utilizado só como exemplo

# Create your views here.

def index(request):
    # 
    # return HttpResponse('<h1>Alura Space</h1><p>Bem vindo ao espaço</p>')
    return render(request, 'index.html')
from django.shortcuts import render
from django.http.response import HttpResponse
from .forms import ContactForm

# Create your views here.
def index(request):
    response = HttpResponse()
    response.write("test1")
    response.write("test2")
    return response
def index_template(request):
    arr = [1,3,5,7,9]
    url_test_data = {
        'app': 'template',
        'hello': 'hello world',
        'arr': arr,
        'flag': False
    }
    return render(request, 'index.html', url_test_data)
def form_test(request):
    form = ContactForm()
    return render(request, 'form_test.html', {
        'form': form,
    })
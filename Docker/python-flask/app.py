from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_geek():
    return '<h1>Hello from Flask & Docker</h2>'

@app.route('/megastar')
@app.route('/powerstar')
@app.route('/megapowerstar')
def hello_geek2():
    return '<h1>Welcome To Megastar Family...!!</h2>'

@app.route('/superstar')
def hello_geek3():
    return '<h1>Welcome To Mahesh...!!</h2>'


if __name__ == "__main__":
    app.run(debug=True)

# #THIS IS A BUGG
import argparse
import requests
import shutil

from bs4 import BeautifulSoup

class ImgurRip(object):
    def __init__(self, board, directory, pages_to_rip):
        self.directory = directory
        self.pages_to_rip = pages_to_rip
        self.session = requests.Session()
        self.url = "https://imgur.com/r/%s" % (board)

    def get_image_names(self):
        image_names = []
        for x in range(0, self.pages_to_rip):
            if x == 0:
                html = self.get_html(self.url)
            else:
                new_page_url = 'new/page/%s/hit?scrolled' % (x)
                html = self.get_html('%s/%s' % (self.url, new_page_url))
            soup = BeautifulSoup(html, 'html.parser')
            for div in soup.find_all('div'):
                try:
                    if div.attrs['class'][0] == 'post':
                        image_names.append(div.attrs['id'])
                except KeyError:
                    continue
        if image_names:
            return image_names
        else:
            print 'Unable to get any images!'
            exit(1)

    def get_html(self, url):
        response = self.session.get(url)
        if not response.ok:
            response.raise_for_status()
        return response.text
    
    def get_image(self, url):
        response = self.session.get(url, stream=True)
        if not response.ok:
            response.raise_for_status()
        response.raw.decode_content = True
        return response
    
    def save_images(self, images):
        for image in images:
            filename = '%s.jpg' % (image)
            full_path = '%s/%s' % (self.directory, filename)
            image_url = 'https://i.imgur.com/%s' % (filename)
            response = self.get_image(image_url)
            if response.headers['Content-Type'] == 'image/gif':
                continue
            if response.status_code == 302:
                continue
            with open(full_path, 'wb') as f:
                print 'Saving image to %s' % (full_path)
                shutil.copyfileobj(response.raw, f)

    def __call__(self):
        print 'Grabbing %s pages of images from %s' % (self.pages_to_rip, self.url)
        self.save_images(self.get_image_names())

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--board", action="store", help="imgur Page", required="True")
    parser.add_argument("--directory", action="store", help="Target directory", default="/tmp")
    parser.add_argument("--pages", action="store", help="Number of pages to rip", default="1")

    args = parser.parse_args()
    board = args.board
    directory = args.directory
    pages_to_rip = int(args.pages)

    ripper = ImgurRip(board, directory, pages_to_rip)
    ripper()

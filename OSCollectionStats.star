load("render.star", "render")
load("http.star", "http")
load("time.star", "time")

COLLECTION_URL = "https://api.opensea.io/api/v1/collection/{}/"
COLLECTIONS = ["the-flower-girls", "cryptomories", "little-lemon-friends", 
    "supducks", "alphagirlclub", "cryptocoven"]

def main():
    random_collection = COLLECTIONS[int(len(COLLECTIONS) * random())]
    collection_url = COLLECTION_URL.format(random_collection)
    print("Fetching OpenSea stats for", collection_url)
    collection_resp = http.get(collection_url)
    if (collection_resp.status_code != 200):
       fail("OpenSea request failed with status", collection_resp.status_code)

    floor = collection_resp.json()["collection"]["stats"]["floor_price"]
    icon_url = collection_resp.json()["collection"]["image_url"]
    icon = http.get(icon_url).body()

    if len(random_collection) > 14:
        title_row = render.Row(
                        children= [
                            render.Marquee(
                                width=64,
                                offset_start=48,
                                child=render.Text(random_collection)
                            ),
                        ]
                    )
    else:
        title_row = render.Row(
                        expanded = True,
                        main_align = "center",
                        cross_align = "center",
                        children = [
                            render.Text(random_collection),
                        ]
                    )

    return render.Root(
        child = render.Box(
            child = render.Column(
                children = [
                    title_row,
                    render.Row(
                        expanded = True,
                        main_align = "center",
                        cross_align = "center",
                        children = [
                            render.Image(
                                src = icon,
                                height = 16,
                                width = 16,
                            ),
                            render.Text(" Ξ%s" % floor),
                        ]
                    ),
                ]
            )
        )
    )

def random():
    """Return a pseudo-random number in [0, 1)"""
    return time.now().nanosecond / (1000 * 1000 * 1000)
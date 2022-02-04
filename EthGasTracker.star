load("render.star", "render")
load("http.star", "http")
load("encoding/base64.star", "base64")
load("cache.star", "cache")

GAS_PRICE_URL = "https://etherchain.org/api/gasnow"

GAS_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAAkAAAAJCAYAAADgkQYQAAAAQElEQVQYlWNgYGBguMrA8B8ZM2AD2BRVhnr8x1AEA8gmoSjEZR1eRXv37oVLwtlkKYJJIismHAROTk7/sWFkNQBc0mLyIWghtgAAAABJRU5ErkJggg==
""")
ETHER_ICON = base64.decode("""
iVBORw0KGgoAAAANSUhEUgAAAA0AAAAUCAYAAABWMrcvAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJQSURBVDhPhZLfS5NRGMefc877bomKOqsVSyOkXziR4U12ExK7iK6iBG+MGc6EiGpisqs1SM0YmMwbK4O8zNCL6A/wrjsvEkKSyGirjblfzLbx7j2nc06nsbcVfW7O8z3P833Oec77wr8I3H/mVWEdWK0WZubX+omuvR0ej3jUloU60+DgK0IwiQICXWN4EYAhlapSZ/L0a36EUJ+I+Xre549cl4kaLKaZ6Fo7IeShkhKE8dzY2KMWJSUWEzHxNO/erqQEIew0QA8rKamaZhfW+7jBr6QVhG75/LM9Sv0yhUIhjBlaFG2FNowK5LJ5ZpqmkGI2DbA9KkKhZdGB1l4fv/u5cqkM8VgCPu3swl4qi77FE5Dey/AmBmCELozcjAyJehSaX2+lP0rb2Uzu8H6hKPYk/CTI5wtK8cYNdmhqaow1EHwWJ7Z3bF+/xDdqDX+jVCyzZCK1sZvO2LDTeaTUdbrzsWEaXsbYB1Vjge9vMVoZcLkOLTh0exmHw8N5Dchlt/vU0NEOh5dPP8WL5L0YsDylNOB0HLx0rNN1AxN9YHU1XJAPUcy1TfPx3C3Nbe/PdHcVdIa7GTUf4Ap1dxx3UVuzbYu/4In9zLuIqK/+V3NPXp8EpG/yZCOjbDP5PRVNZ3L3uO7hJ+cplHtfLgU/i9rqx526e+0jBRoQMcLIgzX8QhiENoHd/m0QVE2C4J0rT/kMb5SUMEZXV5YmVpSUWEwCYpijDCAhYv4QMVyBcZmooc40OXk1CbQyyhhQZtCR5eWJtEr9n0Dw+UUV/gHAT5j04GXGd57xAAAAAElFTkSuQmCC
""")

def main():
    print("Fetching Gas via", GAS_PRICE_URL)
    gas_rep = http.get(GAS_PRICE_URL)
    if (gas_rep.status_code != 200):
       fail("Etherchain request failed with status", gas_rep.status_code)

    ether_price = int(gas_rep.json()["data"]["priceUSD"]) # in USD
    print("Ether Price:", ether_price)
    gas_price = int(gas_rep.json()["data"]["fast"]) / 1000000000 # in Gwei
    print("Gas Price:", gas_price)
    
    return render.Root(
        child = render.Box(
            child = render.Column(
                children = [
                    render.Row(
                        expanded = True,
                        main_align = "center",
                        cross_align = "center",
                        children = [
                            render.Image(src=ETHER_ICON),
                            render.Text(" $%d" % ether_price),
                        ]
                    ),                	
                    render.Row(
                        expanded = True,
                        main_align = "center",
                        children = [
                            render.Image(src=GAS_ICON),
                            render.Text(" %d GWei" % gas_price),
                        ]
                    ),
                ]
            )
        )
    )

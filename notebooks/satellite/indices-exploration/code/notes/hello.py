# Create an @authenticated decorator that only allows the function to run is user1 has 'valid' set to True:
user1 = {
    'name': 'Sorna',
    # changing this will either run or not run the message_friends function.
    'valid': True
}


def authenticated(func):
    def wrapper(*args, **kwargs):
        if args[0]['valid']:
            return func(*args, **kwargs)
        print('not valid')
    return wrapper


@authenticated
def message_friends(user):
    print('message has been sent')


message_friends(user1)

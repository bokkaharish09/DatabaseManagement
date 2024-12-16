import pymysql
from pymysql.cursors import DictCursor
from prettytable import PrettyTable
from datetime import datetime
import getpass  # to hide password when logging into MySQL

# Connect to the database
def connect_to_database(username, password):
    
    try:
        connection = pymysql.connect(
            host='localhost',
            user=username,
            password=password,
            database='AcuCRM'
        )
        if connection.open:
            print("\nConnection to MySQL database established successfully.")
        return connection
    except pymysql.OperationalError as e:
        print(f"Operational error: {e}")
    except pymysql.InternalError as e:
        print(f"Internal database error: {e}")
    except pymysql.MySQLError as e:
        print(f"MySQL error occurred: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    return None

# View Available Products
def get_available_products(connection):
    """Fetch available products from the Product table."""
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("SELECT productID, productName, basePrice FROM Product WHERE isAvailable = TRUE;")
            products = cursor.fetchall()
            if products:
                table = PrettyTable(["ID", "Product Name", "Base Price"])
                for product in products:
                    table.add_row([product['productID'], product['productName'], f"${product['basePrice']:.2f}"])
                print("\nAvailable Products:")
                print(table)
            else:
                print("No available products found.")
            return products
    except pymysql.MySQLError as e:
        print(f"Error retrieving products: {e}")
        return []

#Select Products for a New GiftSet
def select_products(products):
    """Prompt the user to select products for the gift set."""
    selected_product_ids = []
    while True:
        try:
            # print("\nAvailable Products:")
            # table = PrettyTable(["No.", "Product Name", "Base Price"])
            # for idx, product in enumerate(products, start=1):
            #     table.add_row([idx, product['productName'], f"${product['basePrice']:.2f}"])
            # print(table)

            selected_indices = input("Enter the product numbers you want to include in the gift set (e.g., 1,2,3) or type 'back' to return to the menu: ")
            if selected_indices.lower() == 'back':
                return []

            selected_indices = selected_indices.split(',')
            selected_product_ids = [products[int(idx) - 1]['productID'] for idx in selected_indices if idx.strip().isdigit()]
            break
        except (ValueError, IndexError):
            print("Invalid input. Please try again.")
    return selected_product_ids

#User Input to Create a New Giftset
def get_gift_set_details():
    
    gift_set_name = input("Enter the name of the gift set: ")
    while True:
        try:
            discount_percentage = float(input("Enter the discount percentage (0-100): "))
            if 0 <= discount_percentage <= 100:
                break
            else:
                print("Please enter a valid percentage between 0 and 100.")
        except ValueError:
            print("Invalid input. Please enter a numerical value.")
    return gift_set_name, discount_percentage

def create_gift_set(connection, gift_set_name, product_ids, discount_percentage):
    """Call the stored procedure to create a new gift set."""
    try:
        with connection.cursor(DictCursor) as cursor:
            product_ids_str = ','.join(map(str, product_ids))
            
            # Call the stored procedure
            cursor.callproc('CreateGiftSet', [gift_set_name, product_ids_str, discount_percentage])
            
            # Commit the transaction
            connection.commit()
            
            # Fetch the last inserted gift set ID
            cursor.execute("SELECT LAST_INSERT_ID() AS giftSetID;")
            result = cursor.fetchone()

            if result:
                print("\nGift Set Created Successfully!")
                print(f"Gift Set ID: {result['giftSetID']}")
                print(f"Gift Set Name: {gift_set_name}")
                print(f"Discount Percentage: {discount_percentage}")
                
                # Display all gift sets after creation
                display_all_gift_sets(connection)
            else:
                print("Gift set creation failed.")
    except pymysql.MySQLError as e:
        connection.rollback()  # Roll back changes if any error occurs
        print(f"Error while creating gift set: {e}")


#Delete an available giftset
def delete_gift_set(connection):
    """Delete a gift set by its ID."""
    try:
        # Fetch and display all gift sets
        print("\n--- Gift Sets Available for Deletion ---")
        display_all_gift_sets(connection)

        # Prompt the user for giftsetID
        gift_set_id = input("Enter the Gift Set ID to delete (or type 'back' to return to the menu): ").strip()
        if gift_set_id.lower() == "back":
            return
        
        # Confirmation
        confirm = input(f"Are you sure you want to delete Gift Set ID {gift_set_id}? (yes/no): ").strip().lower()
        if confirm != "yes":
            print("Deletion canceled.")
            return

        # Perform the deletion
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("DELETE FROM GiftSet WHERE giftSetID = %s;", (gift_set_id,))
            connection.commit()  # Commit the deletion

            if cursor.rowcount > 0:
                print(f"Gift Set ID {gift_set_id} has been successfully deleted.")
            else:
                print(f"No Gift Set found with ID {gift_set_id}.")
    except pymysql.MySQLError as e:
        connection.rollback()  # Roll back changes if any error occurs
        print(f"Error while deleting gift set: {e}")
    except ValueError:
        print("Invalid input. Please try again.")

#Show all available giftsets
def display_all_gift_sets(connection):

    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("SELECT giftSetID, giftSetName, price AS finalPrice FROM GiftSet;")
            gift_sets = cursor.fetchall()
            if gift_sets:
                table = PrettyTable(["Gift Set ID", "Gift Set Name", "Final Price"])
                for gift_set in gift_sets:
                    table.add_row([gift_set['giftSetID'], gift_set['giftSetName'], f"${gift_set['finalPrice']:.2f}"])
                print("\nAll Available Gift Sets:")
                print(table)
            else:
                print("No gift sets available.")
    except pymysql.MySQLError as e:
        print(f"Error retrieving gift sets: {e}")

#OrderDetails with Customer Names
def fetch_order_details(connection, order_id):
    """Fetch and display order details by Order ID."""
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("""
                SELECT 
                    O.orderID,
                    O.shipDate,
                    O.totalAmount,
                    C.customerID,
                    C.customerType,
                    CASE 
                        WHEN C.customerType = 'Individual' THEN IC.customerName
                        WHEN C.customerType = 'Business' THEN BC.companyName
                        ELSE NULL
                    END AS customerName
                FROM 
                    Orders O
                JOIN 
                    Customer C ON O.customerID = C.customerID
                LEFT JOIN 
                    IndividualCustomer IC ON C.customerID = IC.customerID
                LEFT JOIN 
                    BusinessCustomer BC ON C.customerID = BC.customerID
                WHERE 
                    O.orderID = %s
            """, (order_id,))
            
            order_details = cursor.fetchall()
            
            if order_details:
                table = PrettyTable(["Order ID", "Ship Date", "Customer Name","Total Amount"])
                table.add_row([
                    order_details[0]['orderID'],  
                    order_details[0]['shipDate'], 
                    order_details[0]['customerName'],
                    order_details[0]['totalAmount'],
                ])
                print("\nOrder Summary:")
                print(table)
                return order_details[0]
            else:
                print(f"Order ID {order_id} not found.")
                return None
    except pymysql.MySQLError as e:
        print(f"Error: {e}")
        return None

#update shipping address
def update_shipping_date(connection, order_id, new_shipping_date):
    """Update shipping date for an order and display details before and after the update."""
    try:
        with connection.cursor() as cursor:
            # Retrieve the current order details
            cursor.execute("SELECT orderID, shipDate FROM Orders WHERE orderID = %s", (order_id,))
            order = cursor.fetchone()

            if order:
                # Display order details before the update
                print(f"Order Details Before Update: Order ID = {order[0]}, Shipping Date = {order[1]}")

                # Update the shipping date
                cursor.execute("""
                    UPDATE Orders
                    SET shipDate = %s
                    WHERE orderID = %s
                """, (new_shipping_date, order_id))
                connection.commit()

                # Retrieve and display the updated order details
                cursor.execute("SELECT orderID, shipDate FROM Orders WHERE orderID = %s", (order_id,))
                updated_order = cursor.fetchone()
                print(f"Order Details After Update: Order ID = {updated_order[0]}, Shipping Date = {updated_order[1]}")

                print(f"Shipping date updated successfully for Order ID: {order_id}")
            else:
                print(f"Order ID {order_id} not found.")
    except pymysql.MySQLError as e:
        print(f"Error: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

# Gift Set Submenu
def gift_set_menu(connection):
    """Submenu for Gift Set operations."""
    while True:
        print("\n--- Gift Set Menu ---")
        print("1. View Available Products")
        print("2. Create a New Gift Set")
        print("3. View All Gift Sets")
        print("4. Delete a Gift Set")
        print("5. Return to Main Menu")

        choice = input("Enter your choice: ")
        if choice == "1":
            get_available_products(connection)
        elif choice == "2":
            products = get_available_products(connection)
            if products:
                selected_product_ids = select_products(products)
                if selected_product_ids:
                    gift_set_name, discount_percentage = get_gift_set_details()
                    create_gift_set(connection, gift_set_name, selected_product_ids, discount_percentage)
        elif choice == "3":
            display_all_gift_sets(connection)
        elif choice == "4":
            delete_gift_set(connection)
        elif choice == "5":
            break
        else:
            print("Invalid choice. Please try again.")

# Order Details Submenu
def order_details_menu(connection):
    """Submenu for Order Details operations."""
    while True:
        print("\n--- Order Details Menu ---")
        print("1. View Order Details")
        print("2. Update Shipping Date")
        print("3. Return to Main Menu")

        choice = input("Enter your choice: ")
        if choice == "1":
            try:
                order_id = int(input("Enter the Order ID to view details: "))
                fetch_order_details(connection, order_id)
            except ValueError:
                print("Invalid Order ID. Please enter a valid number.")
        elif choice == "2":
            try:
                order_id = int(input("Enter the Order ID to update shipping date: "))
                
                # Fetch and show existing order details
                order = fetch_order_details(connection, order_id)
                
                if order:
                    shipping_date_input = input("Enter the new shipping date (YYYY-MM-DD): ")
                    try:
                        new_shipping_date = datetime.strptime(shipping_date_input, "%Y-%m-%d").date()
                        update_shipping_date(connection, order_id, new_shipping_date)
                        
                        # Fetch and show updated order details
                        fetch_order_details(connection, order_id)
                    except ValueError:
                        print("Invalid date format. Please use 'YYYY-MM-DD'.")
            except ValueError:
                print("Invalid Order ID. Please enter a valid number.")
        elif choice == "3":
            break
        else:
            print("Invalid choice. Please try again.")


# Support Tickets
def fetch_support_tickets(connection):
    """Fetch support tickets from the SupportTicket table."""
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("SELECT * FROM SupportTicket;")
            tickets = cursor.fetchall()
            if tickets:
                table = PrettyTable(["Ticket ID", "Issue Description", "Status", "Priority", "Creation Date", "Resolved Date"])
                for ticket in tickets:
                    table.add_row([ticket['ticketID'], ticket['issueDesc'], ticket['status'], ticket['priority'], ticket['creationDt'], ticket['resolveDt']])
                print("\nSupport Tickets:")
                print(table)
            else:
                print("No support tickets found.")
    except pymysql.MySQLError as e:
        print(f"Error fetching support tickets: {e}")

# Products
def fetch_products(connection):
    """Fetch products from the Product table."""
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("SELECT productID, productName, SKU, basePrice, isAvailable FROM Product;")
            products = cursor.fetchall()
            if products:
                table = PrettyTable(["Product ID", "Product Name", "SKU", "Base Price", "Availability"])
                for product in products:
                    availability = "Available" if product['isAvailable'] else "Unavailable"
                    table.add_row([product['productID'], product['productName'], product['SKU'], f"${product['basePrice']:.2f}", availability])
                print("\nProducts:")
                print(table)
            else:
                print("No products found.")
    except pymysql.MySQLError as e:
        print(f"Error fetching products: {e}")

# Customers
def fetch_customers(connection):
    """Fetch customer details from Customer and related tables."""
    try:
        with connection.cursor(DictCursor) as cursor:
            cursor.execute("""
                SELECT C.customerID, C.customerType, C.email, C.phone, 
                       IC.customerName, IC.city, BC.companyName 
                FROM Customer C
                LEFT JOIN IndividualCustomer IC ON C.customerID = IC.customerID
                LEFT JOIN BusinessCustomer BC ON C.customerID = BC.customerID;
            """)
            customers = cursor.fetchall()
            if customers:
                table = PrettyTable(["Customer ID", "Type", "Name/Company", "City", "Email", "Phone"])
                for customer in customers:
                    if customer['customerType'] == 'Individual':
                        table.add_row([customer['customerID'], "Individual", customer['customerName'], customer['city'], customer['email'], customer['phone']])
                    elif customer['customerType'] == 'Business':
                        table.add_row([customer['customerID'], "Business", customer['companyName'], "-", customer['email'], customer['phone']])
                print("\nCustomers:")
                print(table)
            else:
                print("No customers found.")
    except pymysql.MySQLError as e:
        print(f"Error fetching customers: {e}")


# Main Menu
def main_menu(connection):
    print(r"""
__        __   _                                  
\ \      / /__| | ___ ___  _ __ ___   ___ 
 \ \ /\ / / _ \ |/ __/ _ \| '_ ` _ \ / _ \ 
  \ V  V /  __/ | (_| (_) | | | | | |  __/ 
   \_/\_/ \___|_|\___\___/|_| |_| |_|\___|   


                 _        
                | |_ ___  
                | __/ _ \ 
                | || (_) |
                 \__\___/ 
          
    _               ____ ____  __  __ 
   / \   ___ _   _ / ___|  _ \|  \/  |
  / _ \ / __| | | | |   | |_) | |\/| |
 / ___ \ (__| |_| | |___|  _ <| |  | |
/_/   \_\___|\__,_|\____|_| \_\_|  |_|

    🌐 Customer Relationship Management! 🌐
""")
    
    while True:
        print("\n--- Main Menu ---")
        print("1. Manage Gift Sets")
        print("2. Manage Orders")
        print("3. View Support Tickets")
        print("4. View Customers")
        print("5. Exit")
        
        choice = input("Enter your choice: ").strip()  # Stripping whitespace for cleaner input

        if choice == "1":
            print("\nRedirecting to Manage Gift Sets...")
            gift_set_menu(connection)
        elif choice == "2":
            print("\nRedirecting to Manage Orders...")
            order_details_menu(connection)
        elif choice == "3":
            print("\nFetching Support Tickets...")
            fetch_support_tickets(connection)
        elif choice == "4":
            print("\nFetching Customer List...")
            fetch_customers(connection)
        elif choice == "5":
            print("\nExiting application. Thank you for using CRM!")
            break
        else:
            print("\n⚠️ Invalid choice. Please select a valid option from the menu.")

# Main Program
if __name__ == "__main__":
    connection = None
    while not connection:
        print("\n*** Enter 'exit' if you wish to stop and close the application ***")
        username = input("\nEnter MySQL username: ")
        if username.lower() == "exit":
            print("\nConnection closed. Thank you!")
            break

        password = getpass.getpass("Enter MySQL password: ") 
        if password.lower() == "exit":
            print("\nConnection closed. Thank you!")
            break

        connection = connect_to_database(username, password)
        if not connection:
            print("\nFailed to connect to the database. Please check your USERNAME and PASSWORD and try again.")
    
    if connection:
        try:
            main_menu(connection)
        finally:
            if connection and connection.open:
                connection.close()
                print("\nConnection closed. Thank you!")
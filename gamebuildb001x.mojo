import pygame
import json
import random

# Initialize Pygame
pygame.init()

# Set window dimensions
width, height = 800, 600
screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("FLAMES64")

# Define colors
BLACK, WHITE, RED, GREEN, GRAY = (0, 0, 0), (255, 255, 255), (255, 0, 0), (0, 255, 0), (50, 50, 50)

# Function to render text
def render_text(surface, text, font_size, position, color=WHITE):
    font = pygame.font.Font(None, font_size)
    text_surface = font.render(text, True, color)
    text_rect = text_surface.get_rect(center=position)
    surface.blit(text_surface, text_rect)

# Function to draw checkered pattern
def draw_checkered_pattern(surface, rect, tile_size):
    colors = [GRAY, WHITE]
    for y in range(rect.top, rect.bottom, tile_size):
        for x in range(rect.left, rect.right, tile_size):
            square = pygame.Rect(x, y, tile_size, tile_size)
            pygame.draw.rect(surface, colors[(x // tile_size) % 2 != (y // tile_size) % 2], square)

# Save Function
def save_game(level):
    save_data = {'level': level}
    with open('savefile.json', 'w') as file:
        json.dump(save_data, file)

# Load Function - Fixed to handle missing 'level' key
def load_game():
    try:
        with open('savefile.json', 'r') as file:
            save_data = json.load(file)
            return save_data.get('level', 1)
    except FileNotFoundError:
        return 1

# Load saved level or set default
current_level = load_game()

# Game state flags
game_started = False
blank_box_visible = False

# Main loop
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE:
                if not game_started:
                    game_started = True
                elif not blank_box_visible:
                    blank_box_visible = True
            elif event.key == pygame.K_s:
                save_game(current_level)
            elif event.key == pygame.K_l:
                current_level = load_game()

    screen.fill(GRAY)

    if not game_started:
        # Draw the checkered pattern in the center
        def draw_blank_box(surface, rect, color):
            pygame.draw.rect(surface, color, rect)

        checkered_rect = pygame.Rect(width // 4, height // 3, width // 2, height // 3)
        draw_checkered_pattern(screen, checkered_rect, 40)

        # Render the GUI text in white color
        render_text(screen, "FLAMES64", 90, (width // 2, 100))
        render_text(screen, "Select Your Plumber", 50, (width // 2, 200))
        render_text(screen, "Press Space to Start", 40, (width // 2, height - 50))

        if blank_box_visible:
            # Draw a blank box in the center
            blank_box_rect = pygame.Rect(width // 4 + 40, height // 3 + 40, width // 2 - 80, height // 3 - 80)
            draw_blank_box(screen, blank_box_rect, BLACK)
    else:
        # Game engine state
        # Example: Move multiple objects on the screen
        for i in range(100):
            x, y = random.randint(0, width), random.randint(0, height)
            pygame.draw.circle(screen, RED, (x, y), 5)

    pygame.display.flip()

pygame.quit()

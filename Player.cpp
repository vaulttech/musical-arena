// Player.cpp
//

#include "Player.h"

#include <ctime>

/////////////////////////////////////////////////////////////////// CONSTRUCTORS
Player::Player()
{
	this->initialize();
}

//////////////////////////////////////////////////////////////////// DESTRUCTORS
Player::~Player()
{	}

////////////////////////////////////////////////////////////// GETTERS & SETTERS
Fretting* Player::getFretting()
{	return fretting;	}


////////////////////////////////////////////////////////////////// OTHER METHODS
void Player::initialize()
{
	srand((unsigned)time(0));
	
	maxHP = 10 + (rand() % 16);
	HP = maxHP;
	maxStamina = 30 + (rand() % 21);
	stamina = maxStamina;
	
	XP = 0;
	level = 1;
	gold = 0;
}

void Player::update()
{
	SEvent *anEvent;

	track->update();
	
	if ( track->nonPressedChord ) // the player left behind a chord he should have played
	{
		fretting->lostNote();
		//cout << "the player left " << track->notesOnChord << " behind" << endl;
	}
	else
	{
		// Creates an vector with only the interesting stones on the screen
		Stone* firstStones[NUMBER_OF_FRETS];
		for(unsigned int i=0; i<NUMBER_OF_FRETS; i++)
			if(track->stones[i].size() > 0)
				firstStones[i] = track->stones[i].front();
			else
				firstStones[i] = NULL;
		if (fretting->receiver->enabled)
		{
			while(anEvent = (fretting->receiver->getEvent()))
			{
				//sem_wait(fretting->receiver->semaphore);
				fretting->verifyEvents( anEvent, firstStones );
				
				// removes the first event of the events vector (so we can deal with the others =D)
				fretting->receiver->removeEvent();
				//sem_post(fretting->receiver->semaphore);
			}
			//cout << "vai verificar eventos" << endl;
			//cout << "terminou de verificar eventos" << endl;
		}
	}
}


